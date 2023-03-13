class CommentsController < ApplicationController


  def create
    comment = Comment.new

    comment.author_id = session.fetch(:user_id)
    comment.photo_id = params.fetch("input_photo_id", nil)
    comment.body = params.fetch("input_body", nil)

    comment.save

    redirect_to("/photos/#{comment.photo_id}")
  end


end
