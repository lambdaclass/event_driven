local_resource("api_service", "mix deps.get && mix compile", deps = "./api_service/lib", dir = "./api_service",
    serve_cmd = "../wait_for_it.sh && mix ecto.setup && mix phx.server", serve_dir = "./api_service", allow_parallel=True,
    resource_deps = ["postgres", "redpanda-0"])

local_resource("marketplace", "mix deps.get && mix compile", deps = "./marketplace/lib", dir = "./marketplace",
    serve_cmd = "../wait_for_it.sh && mix ecto.create && mix ecto.migrate && mix run --no-halt", serve_dir = "./marketplace", allow_parallel=True,
    resource_deps = ["postgres", "redpanda-0"])

local_resource("escrow", "mix deps.get && mix compile", deps = "./escrow/lib", dir = "./escrow",
    serve_cmd = "../wait_for_it.sh && mix ecto.create && mix ecto.migrate && mix run --no-halt", serve_dir = "./escrow", allow_parallel=True,
    resource_deps = ["postgres", "redpanda-0"])

local_resource("notification", "mix deps.get && mix compile", deps = "./notification/lib", dir = "./notification",
    serve_cmd = "mix run --no-halt", serve_dir = "./notification", allow_parallel=True,
    resource_deps = ["postgres", "redpanda-0"])

docker_compose("./docker-compose.yml")
