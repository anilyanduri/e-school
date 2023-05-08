json.extract! batch, :id, :name, :course_id, :status, :created_at, :updated_at
json.url batch_url(batch, format: :json)
