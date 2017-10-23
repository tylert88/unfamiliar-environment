module Users::PerformanceMixin

  def standards_json(standards, user)
    performances = policy_scope(Performance).where(user_id: user).index_by(&:objective_id)
    standards.map do |standard|
      {
        id: standard.id,
        name: standard.name,
        standard_path: standard_path(standard),
        tags: (standard.tags.sort << standard.subject.try(:name)).reject(&:blank?),
        performances: standard.objectives.sort_by(&:position).map do |objective|
          objective_json(objective, performances[objective.id])
        end
      }
    end
  end

  def grouped_standards_json(standards, user)
    performances = policy_scope(Performance).where(user_id: user).index_by(&:objective_id)
    standards.map do |standard, objectives|
      {
        id: standard.id,
        name: standard.name,
        standard_path: standard_path(standard),
        tags: standard.tags,
        performances: objectives.sort_by(&:position).map do |objective|
          objective_json(objective, performances[objective.id])
        end
      }
    end
  end

  def objective_json(objective, performance)
    {
      id: objective.id,
      objective_id: objective.id,
      objective_name: objective.name,
      objective_path: objective_path(objective),
      score: performance.try(:score) || 0,
    }
  end

end
