module UsersHelper

  def user_avatar_url_or_default(user)
    placeholder = "http://placekitten.com/165/110"
    user.avatar.url.present? ? user.avatar.url(:card) : placeholder
  end

end
