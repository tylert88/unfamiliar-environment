class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.timestamps
    end
    add_column :videos, :vimeo_id, :bigint, null: false

    [
      {
        title: "Setup students.galvanize.com locally",
        vimeo_id: 118562704
      },
      {
        title: "Managing Assessments",
        vimeo_id: 118566797
      },
      {
        title: "Employment Tools",
        vimeo_id: 118566761
      },
      {
        title: "Writeups",
        vimeo_id: 118566647
      },
      {
        title: "Pairing Tools",
        vimeo_id: 118566615
      },
      {
        title: "Mentorship",
        vimeo_id: 118566559
      },
    ].each do |video|
      execute <<-SQL
        insert into videos (title, vimeo_id, created_at, updated_at)
        values ('#{video[:title]}', #{video[:vimeo_id]}, now(), now())
      SQL
    end
  end
end
