terraform {
  cloud {
    organization = "prajot-learning"
    workspaces {
      name = "cisco-infra-dev"
    }
  }
}