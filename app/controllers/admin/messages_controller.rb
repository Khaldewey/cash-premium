class Admin::MessagesController < Admin::ResourceController
    def index
        @messages = Message.paginate(page: params[:page], per_page: 5)
    end
end
