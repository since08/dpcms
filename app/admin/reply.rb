ActiveAdmin.register Reply do
  menu false

  member_action :delete_reply, method: [:get, :post] do
    return render :delete unless request.post?
    resource.admin_delete(params[:reason])
    redirect_back fallback_location: admin_comments_url, notice: '删除成功'
  end

  member_action :create_reply, method: [:get, :post] do
    return render :create_reply unless request.post?
    comment = resource.comment
    comment.replies.create!(user: User.official,
                            body: params[:body],
                            topic: comment.topic,
                            reply: resource,
                            reply_user: resource.user)
    redirect_back fallback_location: admin_comments_url, notice: '评论成功'
  end
end
