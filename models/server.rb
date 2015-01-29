class Server
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields
belongs_to :shop
has_many :orders
  # field <name>, :type => <type>, :default => <value>
  field :name, :type => String
  field :price, :type => Float
  field :remark, :type => String
  field :usetime,:type=>Integer

  # You can define indexes on documents using the index macro:
  # index :field <, :unique => true>

  # You can create a composite key in mongoid to replace the default id using the key macro:
  # key :field <, :another_field, :one_more ....>
end
