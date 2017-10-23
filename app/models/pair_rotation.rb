class PairRotation < ActiveRecord::Base
  belongs_to :cohort
  validates :cohort, presence: true

  validates :happened_on, uniqueness: {scope: :cohort, allow_blank: true}
  validates :position, uniqueness: {scope: :cohort}

  before_validation on: :create do
    if cohort && !position
      max_position = self.class.ordered.where(cohort_id: cohort).last.try(:position) || 0
      self.position = max_position + 1
    end
  end

  scope :ordered, ->{ order(:position) }

  def self.for_cohort(cohort)
    where(cohort_id: cohort)
  end

  def self.generate(cohort)
    rotations = round_robin(User.for_cohort(cohort).sort_by(&:full_name).map(&:id))
    position = where(cohort_id: cohort).maximum(:position) || 0
    transaction do
      rotations.each.with_index(position + 1) do |rotation, index|
        create!(
          cohort: cohort,
          pairs: rotation,
          position: index,
        )
      end
    end
  end

  #http://en.wikipedia.org/wiki/Round-robin_tournament#Scheduling_algorithm
  def self.round_robin(ids)
    ids = ids + [nil] if ids.length.odd?
    h = ids.length / 2
    a,b = ids.each_slice(h).to_a
    first, *rest = a + b.reverse

    (ids.length - 1).times.map do |i|
      x = rest[0..h - 2]
      y = rest[h - 1..-1]
      x.unshift(y.shift)
      y << x.pop
      rest = x + y
      ([first] + x).zip(y)
    end
  end

end
