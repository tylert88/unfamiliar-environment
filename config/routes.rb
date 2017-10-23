Students::Application.routes.draw do

  root :to => "public#index"
  # new pages, behind a feature flag
  get 'new-root' => redirect('/')
  get 'people/:id' => "public#show", as: :public_student

  get 'signin' => "sessions#new", as: :signin
  post 'signin' => "sessions#sign_in_with_password"
  get 'set_password/:verifier' => "sessions#set_password", as: :set_password
  post 'set_password/:verifier' => "sessions#update_password"

  get "/preparation" => "public_pages#preparation_index", :as => "preparations"
  get "/preparation/:id" => "public_pages#preparation", :as => "preparation"
  get "/calendar" => "public_pages#calendar", :as => "calendar"
  resources :showcases
  resources :students, :only => :show

  get "/auth/:provider/callback" => "sessions#create"
  get "/auth/failure" => "sessions#failure"
  get "/logout" => "sessions#destroy", :as => "logout"

  get "/mentors/:user_id" => "mentors#show", :as => :mentor

  resources :timelines, only: :index
  resources :campuses
  resources :courses do
    post :clone, on: :member
    resources :expectations
  end
  resources :job_activities, only: [] do
    get :all, on: :collection
  end
  resources :assessments
  resources :given_assessments, only: :create
  resources :enrollments
  resources :videos, only: :index

  resources :curriculums, only: [] do
    resources :learning_experiences do
      get :reorder, on: :collection
      post :reorder, on: :collection, action: :update_order
      get :assign, on: :collection
      post :assign, on: :member, action: :create_assignment
    end
    resources :exercises
  end

  resources :curriculums, module: :instructor do
    get :new_import, on: :member
    post :import, on: :member
    get :progress, on: :member
    get :activity, on: :member
    resources :standards, only: [:index, :new, :create] do
      get :reorder, on: :collection
      post :reorder, on: :collection, action: :update_order
    end
    resources :subjects do
      get :reorder, on: :collection
      post :reorder, on: :collection, action: :update_order
    end
  end
  resources :standards, module: :instructor do
    post :merge_objectives, on: :member
    get :delete, on: :member
    resources :objectives, only: [:new, :create] do
      get :reorder, on: :collection
      post :reorder, on: :collection, action: :update_order
    end
  end
  resources :objectives, module: :instructor do
    get :delete, on: :member
  end

  namespace :api do
    get 'me' => 'base#me'
    post '/apps/:app_name/authenticate' => 'apps#authenticate'
    get 'sign-in' => 'auth#sign_in'
    resources :cohort_exercises, only: [] do
      resources :submissions, only: :index
    end
    resources :class_projects, only: :index
    resources :students, only: :index
    resources :student_projects, only: :index
    resources :stories
    resources :cohorts, only: :index do
      get :current, on: :collection
      resources :students, only: :index
    end
    get '/autograder/:cohort_id' => 'autograder#show'
  end

  get '/redirects/learning_experiences/:id' => 'redirects#learning_experience'

  resources :users do
    resources :performances, controller: 'users/performances' do
      post :update_all, on: :collection
    end
    resources :learning_experiences, controller: 'users/learning_experiences', only: [:index, :show]
    resources :expectations, controller: 'users/expectations' do
      resources :expectation_statuses do
        post :publish, on: :member
        post :mark_as_read, on: :member
      end
    end
    resources :taken_assessments do
      patch :submit, on: :member
      post :track, on: :member
    end
    resources :employments, except: [:index, :show]
    resource :employment_profile
    resources :job_activities
    resources :tracker_statuses
    resources :projects
    resources :epics, controller: 'user_epics' do
      post :add_to_tracker, on: :member
    end
    resources :submitted_exercises, only: [] do
      get :generate_dot_file, on: :collection
    end
    get "/student_dashboard", to: "instructor/student_dashboard#show", on: :member
  end

  resources :epics do
    resources :cohorts, controller: 'cohort_epics'
  end

  resources :class_projects do
    resources :epics do
      resources :stories do
        post :reorder, on: :collection
      end
      post :reorder, on: :collection
    end
  end

  resources :learning_experiences, only: [] do
    resources :zpd_responses, only: [:new, :create, :index], controller: "learning_experiences/zpd_responses"
  end

  resources :writeups, only: [] do
    resources :comments, controller: 'writeup_comments'
  end

  resources :cohorts do
    resources :performances do
      get :data, on: :collection
    end
    resources :pair_rotations do
      post :generate, on: :collection
      post :assign, on: :member
      post :unassign, on: :member
      get :random, on: :collection
    end
    resources :given_assessments do
      get 'score/:question_id', action: 'score', as: :score
      post 'score/:question_id', action: 'submit_scores'
      post :pull_changes, on: :member
    end
    get :one_on_ones, :on => :member
    post :send_one_on_ones, on: :member
    get :acceptance, :on => :member
    post :refresh_acceptance, :on => :member
    get :mentorships, :on => :member
    get :social, :on => :member
    get "/student_dashboard", to: "student/student_dashboard#index"

    resource :student_dashboard, only: [:index] do
      get "js_challenges", to: "student/student_dashboard#js_challenges"
    end

    get "/info" => "student/info#index", :as => "info"
    get "/prereqs" => "student/info#prereqs", :as => "prereqs"

    resources :applications, only: [:index], controller: 'greenhouse_applications' do
      post :refresh, on: :collection
      post :import, on: :member
    end
    resources :writeups, controller: 'student/writeups', only: :index
    resources :writeup_topics, only: [] do
      resources :writeups, only: [:new, :create, :edit, :update, :destroy], controller: 'student/writeups'
    end
    resources :pairings, controller: 'student/pairings'
    resources :students, :only => [:index, :show], controller: 'student/students' do
      resources :mentorships
    end
    resources :exercises, :only => [:index, :show], controller: 'student/exercises' do
      resources :submissions, :only => [:new, :create, :edit, :update], controller: 'student/submissions'
    end
    resources :action_plan_entries, controller: 'student/action_plan_entries', only: :index
    resources :daily_plans do
      get :today, on: :collection
      get :search, on: :collection
    end

    resources :staffings, except: [:show] do
      post :add_as_owner, on: :member
    end
    resources :imports, only: [:index, :create]

    resources :student_deadlines, controller: 'student/student_deadlines', only: [:index, :edit, :update]
    resources :assignment_submissions, controller: 'student/assignment_submissions', only: [:index, :edit, :update, :show]
    resources :zpd_responses, controller: 'student/zpd_responses', except: [:destroy]
    resources :student_challenges, controller: 'student/student_challenges'
    resources :student_snippets, controller: 'student/student_snippets', only: [:index, :create, :show, :update]
  end

  namespace :instructor do
    resources :cohorts, only: [] do
      resources :writeup_topics do
        resources :writeups
      end
      resources :tracker_accounts do
        delete :destroy, on: :collection
      end
      resources :students, :only => [] do
        resources :action_plan_entries
      end
      resources :projects, only: :index
      resources :action_plans, only: :index
      resources :cohort_exercises
      resources :deadlines do
        resources :student_deadlines, only: [:index]
      end
      resources :assignments
      resources :assignment_submissions, only: [] do
        patch :toggle, on: :member
      end
      resources :challenges, only: [:new, :create, :index, :show]
      resources :zpd_responses, only: [:index]
      resources :assignment_submissions, only: [] do
        resources :assignment_submission_notes, except: [:index]
      end
      resources :snippets, only: [:index, :new, :create, :show] do
        resources :student_snippets, only: [:show]
      end
    end
  end
end
