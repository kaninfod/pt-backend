namespace :phototank do
  desc "Initialize the app"
  task initialize: :environment do
    Setting.master_catalog = MasterCatalog.create_master

    ['tm', 'md', 'lg'].each do |ext|
      path = File.join(Rails.root,'config','setup', "generic_#{ext}.jpg")
      payload = {
        :path=> path,
        :filetype=> "system",
      }
      response = Photofile.create(data:payload)
      Setting["generic_image_#{ext}_id"] = response[:id]
    end
  end


  desc "Create the Master catalog"
  task create_master_catalog: :environment do
    MasterCatalog.create_master
  end

  desc "add generic photos (eg missing)"
  task Add_generic_photo: :environment do
    pf = PhotoFilesApi::Api::new
    ['tm', 'md', 'lg'].each do |ext|
      image_path = File.join(Rails.root,'app','assets','images', "generic_#{ext}.jpg")
      response = pf.create image_path, nil, nil, 'generic_image'
      Setting["generic_image_#{ext}_id"] = response[:id]
    end

  end
  desc "Set the updating flag to false to allow updates"
  task master_not_updating: :environment do
    Catalog.master.settings.updating = false
  end
end
