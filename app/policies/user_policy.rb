class UserPolicy < ApplicationPolicy

  def index?
    user.instructor?
  end

  def show?
    user.instructor? || user.cohorts.any?{ |cohort| record.cohorts.include?(cohort) }
  end

  def new?
    user.instructor?
  end

  def create?
    user.instructor?
  end

  def edit?
    self_or_instructor?
  end

  def update?
    self_or_instructor?
  end

  def destroy?
    false
  end

  def permitted_attributes
    attributes = []

    if self_or_instructor?
      attributes += [
        :first_name,
        :last_name,
        :email,
        :phone,
        :twitter,
        :blog,
        :address_1,
        :address_2,
        :city,
        :state,
        :zip_code,
        :linkedin,
        :avatar,
        :shirt_size,
        :pivotal_tracker_token,
        :password,
      ]
    end

    if user.instructor?
      attributes += [
        :role,
        :status,
        :github_username,
        :github_id,
        :galvanize_id,
        :greenhouse_candidate_id,
      ]
    end

    attributes
  end

  private def self_or_instructor?
    user.instructor? || user == record
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
