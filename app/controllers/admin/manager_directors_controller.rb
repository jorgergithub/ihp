class Admin::ManagerDirectorsController < AuthorizedController
  before_filter :find_manager_director

  def index
    @manager_directors = ManagerDirector.manager_directors
      .order("users.first_name, users.last_name")
      .page(params[:page]).per(params[:per])
  end

  def new
    @manager_director = ManagerDirector.new(create_as: "manager_director")
  end

  def edit
  end

  def create
    params = manager_director_params.merge(create_as: "manager_director")
    @manager_director = ManagerDirector.new(params)
    @manager_director.skip_confirmation!
    if @manager_director.save
      redirect_to admin_manager_directors_path,
        notice: "New Managing Director was successfully created."
    else
      render action: "edit"
    end
  end

  protected

  def find_manager_director
    @manager_director = ManagerDirector.find(params[:id]) if params[:id]
  end

  def manager_director_params
    params.require(:manager_director).permit(:first_name, :last_name, :username,
                                             :email, :password, :time_zone)
  end
end
