ActiveAdmin.register VideoGroup do
  menu false

  controller do
    before_action :set_group, only: [:edit, :update]
    def edit
      render :new
    end

    def update
      @video_group.assign_attributes(group_params)
      respond_to do |format|
        if @video_group.save
          format.js { render :success }
        else
          format.js { render :error }
        end
      end
    end

    def set_group
      @video_group = VideoGroup.find(params[:id])
    end

    def group_params
      params.require(:video_group).permit(:name, video_group_en_attributes: [:name])
    end
  end
end
