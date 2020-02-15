require "rails_helper"

describe "/photos - Create photo form" do
  it "automatically populates owner_id of new photo with id of the signed in user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    new_caption = "Some new test caption #{Time.now.to_i}"

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = new_caption
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      find("button", :text => /Sign in/i ).click
    end
    
    visit "/photos"
    within(:css, "form") do
      fill_in "Image", with: "https://some.test/image-#{Time.now.to_i}.jpg"
      fill_in "Caption", with: new_caption
      find("button", :text => /Add photo/i ).click
    end
    

    expect(page).to have_text(new_caption),
      "Expected page to contain #{new_caption}, but didn't."
  end
end

describe "/photos/[ID] - Update photo form" do
  it "does not display Update photo form when photo does not belong to current user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    bob = User.new
    bob.password = "password"
    bob.username = "bob"
    bob.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: bob.username
      fill_in "Password", with: bob.password
      find("button", :text => /Sign in/i ).click
    end
    
    visit "/photos/#{photo.id}"


    # expect(page).to have_text("Update photo")
    expect(page).not_to have_tag("button", :text => /Update photo/i),
      "Expected page to not have a button with the text 'Update photo', but found one."
  end
end

describe "/photos/[ID] - Update photo form" do
  it "displays Update photo form when photo belongs to current user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      find("button", :text => /Sign in/i ).click
    end
    
    visit "/photos/#{photo.id}"


    # expect(page).to have_text("Update photo")
    expect(page).to have_tag("button", :text => /Update photo/i),
      "Expected page to have a button with the text 'Update photo', but didn't find one."
  end
end

describe "/photos/[ID] - Delete this photo button" do
  it "displays Delete this photo button when photo belongs to current user", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      find("button", :text => /Sign in/i ).click
    end
    
    visit "/photos/#{photo.id}"

    expect(page).to have_content(first_user.username),
      "Expected to find the User's username, but didn't find it."

    # expect(page).to have_link("Delete this photo")
    expect(page).to have_tag("a", :text => /Delete this photo/i ),
      "Expected page to have a link with the text 'Delete this photo', but didn't find one."
  end
end

describe "/photos/[ID] — Add comment form" do
  it "automatically associates comment with signed in user and current photo", points: 2 do
    first_user = User.new
    first_user.password = "password"
    first_user.username = "alice"
    first_user.save

    photo = Photo.new
    photo.image = "https://some.test/image-#{Time.now.to_i}.jpg"
    photo.caption = "Some test caption #{Time.now.to_i}"
    photo.owner_id = first_user.id
    photo.save

    visit "/user_sign_in"
    
    within(:css, "form") do
      fill_in "Username", with: first_user.username
      fill_in "Password", with: first_user.password
      find("button", :text => /Sign in/i ).click
    end

    test_comment = "Hey, what a nice app you're building!"

    visit "/photos/#{photo.id}"

    fill_in "Comment", with: test_comment

    find("button", :text => /Add comment/i ).click

    added_comment = Comment.where({ :author_id => first_user.id, :photo_id => photo.id, :body => test_comment }).at(0)

    expect(added_comment).to_not be_nil,
      "Expected to create a new Comment record by visiting the photo details page, entering text in the 'Comment' field and clicking 'Add comment' but comment did not save."
  end
end
