ActiveAdmin.register PlayerImage do
  menu false

  collection_action :increase_image, method: [:get, :post] do
    @player = Player.find(params[:player_id])
    return render 'number_limit' if @player.player_images.count >= 3
    return render 'increase_image' unless request.post?
    return render 'common/params_format_error' if params[:image].blank?
    @player.player_images.create(image: params[:image])
    render 'option_success'
  end

  member_action :delete_image, method: [:post] do
    @player = resource.player
    resource.destroy!
    render 'option_success'
  end
end
