json.extract! course, :id, :name, :description, :material, :school_id, :status, :created_at, :updated_at
json.url course_url(course, format: :json)
