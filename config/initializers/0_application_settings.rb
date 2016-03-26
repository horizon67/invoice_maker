# ファイル名に0_をつけることで一番最初にsettingslogicのinitializerが読み込まれるようにしている
class ApplicationSettings < Settingslogic
  source "#{Rails.root}/config/settings/application_settings.yml"
  namespace Rails.env
end
