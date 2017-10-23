class ImportsController < ApplicationController

  def index
    authorize(:import, :any?)
  end

  def create
    authorize(:import, :any?)
    headers, @saved, @failed = import_csv
    if @failed.empty?
      redirect_to(
        cohort_path(@cohort),
        notice: "#{view_context.pluralize(@saved.length, "student")} were imported successfully!"
      )
    else
      @text = [headers.to_csv.strip]
      @text += @failed.values.map{|info| info[:row].to_csv.strip }
      @text = @text.join("\n")
      render :index
    end
  end

  private

  def header_fields
    %w(first_name last_name email phone twitter blog address_1 address_2 city state zip_code linkedin github_username)
  end

  helper_method :header_fields

  def import_csv
    saved, failed = {}, {}
    i = 1
    headers = []
    CSV.parse(params[:student_csv], headers: true, skip_blanks: true) do |row|
      headers = row.headers
      user = User.new(
        role: :user,
        enrollments: [
          Enrollment.new(cohort: @cohort, status: :enrolled, role: :student)
        ]
      )
      header_fields.each { |field| user.send("#{field}=", row[field].to_s.strip) }
      if user.save
        if !params[:invitation_type].empty?
          StudentMailer.invitation(user, params[:invitation_type]).deliver
        end
        saved[i] = user
      else
        failed[i] = {user: user, row: row}
      end
      i += 1
    end
    return headers, saved, failed
  end

end
