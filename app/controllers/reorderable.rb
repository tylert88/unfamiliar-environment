module Reorderable

  def update_positions(records)
    records.each.with_index(records.map(&:position).max + 1) do |record, index|
      record.update_column(:position, index)
    end
    records.each do |record|
      record.update_column(:position, params[:positions][record.id.to_s])
    end
    render nothing: true
  end

end
