class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index,:edit, :update,:destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,only: :destroy
  #用户首页
  def index
    #@users=User.all
    @users=User.paginate(page: params[:page])
  end
  #用户注册
  def create
  	@user=User.new(user_params)
  	if @user.save
  		sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  	    render 'new'
  	end
  end
  #用户详情
  def show
    @user = User.find(params[:id])
    @micropost = @user.microposts.build()
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  #进入用户注册页面
  def new
  	@user =  User.new
  end
  #进入编辑用户信息
  def edit
    @user=User.find(params[:id])
  end
  #编辑用户信息
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flush[:success]="用户信息编辑成功"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end 
   end
   #删除 用户，根据权限控制，只有管理员才能删除用户
   def destroy
   	  User.find(params[:id]).destroy
   	  flush[:success]="删除成功"
   	  redirect_to users_url
   end
  #Define User params now by haipeng
  private 
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
   
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
