class ErrorsController < ApplicationController

  TestException = Class.new(StandardError)

  def new
    raise TestException, 'Test exception. All is well.'
  end

end
