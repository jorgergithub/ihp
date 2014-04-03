class Admin::TrainingItemsController < AuthorizedController
  before_filter :find_training_item
end
