ActiveAdmin.register CrowdfundingReport do
  permit_params :record_time, :name, :title, :level, :small_blind,
                :big_blind, :ante, :crowdfunding_player_id, :description
  belongs_to :crowdfunding

  filter :name_or_title, as: :string
  filter :record_time
  filter :created_at
  filter :crowdfunding_player_player_name, as: :string

  form partial: 'form'

  index do
    render 'index', context: self
  end
end
