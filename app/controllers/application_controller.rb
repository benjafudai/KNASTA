class ApplicationController < ActionController::Base
  # No allow_browser restriction: the site must work on older phones too.

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
