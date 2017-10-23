class ObjectiveMerger

  attr_reader :message, :success

  def self.merge(objective_ids, new_name, instructor)
    merger = new(objective_ids, new_name, instructor)
    merger.merge
  end

  def initialize(objective_ids, new_name, instructor)
    @objective_ids = objective_ids
    @new_name = new_name
    @instructor = instructor
  end

  def merge
    return if @objective_ids.empty?
    @message = ""

    Objective.transaction do
      begin
        objectives = Objective.find(@objective_ids)

        begin
          @new_objective = Objective.create!(
            name: @new_name,
            standard: objectives.first.standard,
            description: "#{ objectives.map{|o|  "- #{o.name}"}.join("\n") }\n\n#{objectives.map(&:description).join("\n\n")}",
            guiding_questions: objectives.map(&:guiding_questions).join("\n\n"),
            resources: objectives.map(&:resources).join("\n\n"),
            instructor_notes: objectives.map(&:instructor_notes).join("\n\n"),
          )
        rescue Exception => e
          @message = "Problem creating objective \"#{@new_name}\": " + e.message
          raise e
        end

        all_performances = Performance.where(objective_id: objectives)
        all_performances.group_by(&:user).each do |user, performances|
          next unless user
          max_score = performances.map(&:score).max
          begin
            Performance.create!(objective: new_objective, score: max_score, user: user, updator: @instructor)
          rescue Exception => e
            @message = "Problem merging performances for \"#{user.full_name}\": " + e.message
            raise e
          end
        end

        objectives.each(&:destroy)
        all_performances.each(&:destroy)
        @message = "Merge was successful"
        @success = true
      rescue Exception => e
        Rails.logger.warn(e.message)
        Rails.logger.warn(e.backtrace.join("\n"))
        @success = false
        raise ActiveRecord::Rollback
      end
    end
    self
  end

  def new_objective
    @new_objective
  end

end
