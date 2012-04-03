class BasePresenter
  def self.as_collection(collection)
    collection.collect{|object| self.new(object)}
  end
end