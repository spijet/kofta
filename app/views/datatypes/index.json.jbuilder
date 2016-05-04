json.array!(@datatypes) do |datatype|
  json.extract! datatype, :id, :name, :oid, :excludes, :metric_type, :table, :index_oid
  json.url datatype_url(datatype, format: :json)
end
