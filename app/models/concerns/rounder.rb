module Rounder
  extend ActiveSupport::Concern

  include ActionView::Helpers::NumberHelper

  def round(param)
    number_with_precision(param, precision: 1)
  end

  end