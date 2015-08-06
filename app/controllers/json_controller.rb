class JsonController < ActionController::Metal
  
  include AbstractController::Helpers
  include ActionController::Helpers
  include ActionController::Rendering
  include ActionController::Renderers::All
  include ActionController::Cookies

  include YV::Concerns::UserAuth


  # Routes
  # get "/highlights/:version/:reference"
  def reference_highlights
    highlights = current_auth ? Highlight.for_reader(auth: current_auth, user_id: current_auth.user_id, version_id: params[:version], usfm: usfm_param) : []
    render json: highlights.to_json
  end

  def reference_bookmarks
    bookmarks = current_auth ? Bookmark.for_reader(auth: current_auth, user_id: current_auth.user_id, version_id: params[:version], usfm: usfm_param) : []
    render json: bookmarks.to_json
  end

  include NewRelic::Agent::Instrumentation::ControllerInstrumentation
  add_transaction_tracer :reference_highlights


  def highlight_colors
    render json: Highlight.colors(auth: (current_auth rescue nil)).slice(0,10).to_json
  end

  include NewRelic::Agent::Instrumentation::ControllerInstrumentation
  add_transaction_tracer :highlight_colors


  def bookmarks_labels
    labels = logged_in? ? Bookmark.labels(auth: current_auth) : []
    render json: labels.to_json
  end

  include NewRelic::Agent::Instrumentation::ControllerInstrumentation
  add_transaction_tracer :bookmarks_labels

  private

  def usfm_param
    pieces = params[:reference].split(".")
    "#{pieces.first.upcase}.#{pieces.second}" # JHN.1 from jhn.1.kjv
  end

end