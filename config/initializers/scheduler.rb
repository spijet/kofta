# coding: utf-8
# frozen_string_literal: true

Schedule.fill if defined?(Rails::Server) || $PROGRAM_NAME.include?('puma')
