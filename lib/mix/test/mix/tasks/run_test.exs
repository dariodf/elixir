Code.require_file "../../../test_helper", __FILE__

defmodule Mix.Tasks.RunTest do
  use MixTest.Case

  defmodule GetApp do
    def project do
      [
        app: :get_app,
        version: "0.1.0",
        deps: [
          { :git_repo, "0.1.0", git: MixTest.Case.fixture_path("git_repo") }
        ]
      ]
    end

    def location do
      __FILE__
    end
  end

  test "run command with dependencies" do
    Mix.Project.push GetApp

    in_fixture "only_mixfile", fn ->
      Mix.Tasks.Deps.Get.run []
      Mix.Tasks.Run.run ["Mix.shell.info", "GitRepo.hello", "--unknown"]
      assert_received { :mix_shell, :info, ["World"] }
    end
  after
    purge [GitRepo, GitRepo.Mix]
    Mix.Project.pop
  end
end