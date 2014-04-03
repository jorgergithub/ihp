class Ability
  include CanCan::Ability

  def initialize(user)
    can :access, :home
    can :access, :horoscopes
    can :create, :sessions
    can [:callback, :success, :cancel], :paypal
    can [:create], "calls/psychic_callbacks"
    can [:create], "calls/client_callbacks"
    can [:index, :user, :pin, :transfer, :do_transfer, :topup, :buy_credits, :confirm_credits, :call_finished, :notify, :phone_number], :calls
    can [:twitter, :facebook, :google_oauth2, :all], :omniauth_callbacks
    can [:create, :confirmation], :registrations
    can [:new, :edit, :show, :create, :update], "devise/confirmations"
    can [:new, :edit, :show, :create, :update], :passwords
    can [:create, :edit], :messages
    can [:create, :edit], :applications
    can [:index, :show], :faqs
    can [:about, :search], :psychics
    can [:new, :create], :psychic_applications

    if user
      authorize_user(user)
    else
      authorize_guests
    end
  end

  private

  def authorize_user(user)
    can :destroy, :sessions
    can :update, :registrations

    if user.role
      self.send("authorize_#{user.role}")
    end
  end

  def admin_roles
    %w(
      admin/accountants
      admin/calls
      admin/categories
      admin/clients
      admin/customer_service_representatives
      admin/daily_fortunes
      admin/dashboards
      admin/debug
      admin/horoscopes
      admin/manager_directors
      admin/newsletters
      admin/orders
      orders
      admin/packages
      admin/psychic_faq_categories
      admin/psychics
      admin/refunds
      admin/call_surveys
      admin/reviews
      admin/schedule_jobs
      admin/subscribers
      admin/surveys
      admin/website_admins
      admin/invoices
    )
  end

  def website_admin_roles
    %w(
      admin/categories
      admin/daily_fortunes
      admin/dashboards
      admin/horoscopes
      admin/psychic_faq_categories
    )
  end

  def csr_roles
    %w(
      customer_service_representatives
      admin/calls
      admin/clients
      admin/orders
      orders
      admin/psychics
      admin/refunds
    )
  end

  def authorize_accountant
    can :access, %w(admin/invoices admin/payments)
  end

  def authorize_admin
    can :access, admin_roles
  end

  def authorize_website_admin
    can :access, website_admin_roles
  end

  def authorize_client
    can [:update, :edit, :show, :reset_pin, :make_favorite, :remove_favorite, :avatar, :destroy_card], :clients
    can [:show, :new, :create, :paypal], :orders
    can [:search, :about], :psychics
    can [:callback, :success, :cancel], :paypal
    can [:new, :create], :callbacks
    can :access, :client_phones
    can :access, :surveys
  end

  def authorize_csr
    can :access, csr_roles
  end

  def authorize_guests
    can [:new, :create, :confirmation], :psychic_applications
  end

  def authorize_manager_director
    can :access, %w(admin/psychic_applications admin/psychics)
  end

  def authorize_psychic
    can :access, [:psychics, :schedules, :invoices, :reviews, :avatar]
    can [:mark_as_featured, :unmark_as_featured], :reviews
    can [:index, :show], :training_items
    can [:index, :show], :psychic_faqs
  end
end
