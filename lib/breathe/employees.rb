module Breathe
  class Employees < Resource
    RESOURCE_NAME = "employees"
    SUPPORTED_ENDPOINTS = [
      :list,
      :get
    ]
  end
end
