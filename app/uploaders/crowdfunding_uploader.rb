class CrowdfundingUploader < BaseUploader
  def store_dir
    "uploads/crowdfunding/#{mounted_as}/#{model.id}"
  end
end