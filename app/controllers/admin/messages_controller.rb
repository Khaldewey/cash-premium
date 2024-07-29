class Admin::MessagesController < Admin::ResourceController
    def index
        @messages = Message.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
    end
end
