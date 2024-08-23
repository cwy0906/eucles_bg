class CommonMessage
  include ActiveModel::Model

  attr_accessor :title, :tag, :content
  validates_presence_of :title, :tag, :content

end