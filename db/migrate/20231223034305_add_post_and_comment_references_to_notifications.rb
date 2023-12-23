class AddPostAndCommentReferencesToNotifications < ActiveRecord::Migration[7.0]
  def change
    add_reference :notifications, :post, null: true, foreign_key: true
    add_reference :notifications, :comment, null: true, foreign_key: true
  end
end
