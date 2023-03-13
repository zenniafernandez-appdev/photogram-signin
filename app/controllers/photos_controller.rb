class PhotosController < ApplicationController
  def index
    @photos = Photo.all
    render({ :template => "photos/all_photos.html.erb"})
  end

  def create
    user_id = session.fetch(:user_id)
    image = params.fetch("input_image")
    caption = params.fetch("input_caption")
    photo = Photo.new
    photo.owner_id = user_id
    photo.image = image
    photo.caption = caption
    photo.save
    redirect_to("/photos/#{photo.id}")
  end

  def show
    p_id = params.fetch("the_photo_id")
    @photo = Photo.where({:id => p_id }).first
    render({:template => "photos/details.html.erb"})
  end

  def destroy
    id = params.fetch("the_photo_id")
    photo = Photo.where({ :id => id }).at(0)
    photo.destroy

    redirect_to("/photos")
  end

  def update

    # if the session :user_id matches the photo :owner_id, allow update form
    # if not, hide form

    id = params.fetch("the_photo_id")
    photo = Photo.where({ :id => id }).at(0)
    photo.caption = params.fetch("input_caption")
    photo.image = params.fetch("input_image")
    photo.save

    redirect_to("/photos/#{photo.id}")
  end
end

# def authenticate
#   # Parameters: {"input_username"=>"zzz", "input_password"=>"[FILTERED]"}
  
#   un = params.fetch("input_username")
#   pw = params.fetch("input_password")

#   # look up the record from the db matching username
#   user = User.where({ :username => un }).at(0)

#   # if there's no record, redirect back to sign in form
#   if user == nil
#     redirect_to("/user_sign_in", { :alert => "No one by that name here." })
#   else
#     # if there is a record, check to see if password matches
#     if user.authenticate(pw)
#       # if so, set the cookie
#       session.store(:user_id, user.id)

#       redirect_to("/", { :notice => "Welcome back, " + user.username + "!" })
#     else
#       # if not, redirect back to sign in form
#       redirect_to("/user_sign_in", { :alert => "Incorrect password. Please try again." })
#     end
#   end
