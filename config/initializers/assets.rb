# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "raw"))
FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "data"))

FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "images", "champion_icons"))
FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "images", "items"))
FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "images", "profile_icons"))
FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "images", "passives"))
FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "images", "spells"))
FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "images", "stats"))
FileUtils.mkdir_p(Rails.root.join("vendor", "assets", "images", "runes"))

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("vendor", "assets", "images")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.after_initialize do
  Riot::DDragonService.update! if Summoner.table_exists?
end
