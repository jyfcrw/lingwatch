json.(@user, :id, :name, :phone, :created_at, :sms_confirmed_at, :last_login_at)
json.avatar_url public_url(File.join("/", @user.avatar.thumb.url)) if @user.avatar
