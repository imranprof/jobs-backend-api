class RemoveRatingAndFeedBackFromJobApplication < ActiveRecord::Migration[7.0]
  def change
    remove_column :job_applications, :feedback
    remove_column :job_applications, :rating
  end
end
