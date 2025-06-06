import ./make-test-python.nix (
  { pkgs, ... }:
  rec {
    name = "tracee-integration";
    meta.maintainers = pkgs.tracee.meta.maintainers;

    passthru.hello-world-builder =
      pkgs:
      pkgs.dockerTools.buildImage {
        name = "hello-world";
        tag = "latest";
        config.Cmd = [ "${pkgs.hello}/bin/hello" ];
      };

    nodes = {
      machine =
        { config, pkgs, ... }:
        {
          # EventFilters/trace_only_events_from_new_containers and
          # Test_EventFilters/trace_only_events_from_"dockerd"_binary_and_contain_it's_pid
          # require docker/dockerd
          virtualisation.docker.enable = true;
          environment = {
            variables.PATH = "/tmp/testdir";
            systemPackages = with pkgs; [
              # 'ls', 'uname' and 'who' are required by many tests in event_filters_test.go
              coreutils
              # the go integration tests as a binary
              tracee.passthru.tests.integration-test-cli
            ];
          };
        };
    };

    testScript =
      let
        skippedTests = [
          # these comm tests for some reason do not resolve.
          # something about the test is different as it works fine if I replicate
          # the policies and run tracee myself but doesn't work in the integration
          # test either with the automatic run or running the commands by hand
          # while it's searching.
          "Test_EventFilters/comm:_event:_data:_trace_event_magic_write_set_in_multiple_policies_using_multiple_filter_types"
          "Test_EventFilters/comm:_event:_data:_trace_event_security_file_open_and_magic_write_using_multiple_filter_types"
          "Test_EventFilters/comm:_event:_data:_trace_event_security_file_open_and_magic_write_using_multiple_filter_types_combined"
          "Test_EventFilters/comm:_event:_data:_trace_event_security_file_open_set_in_multiple_policies_\\(with_and_without_in-kernel_filter\\)"
          "Test_EventFilters/comm:_event:_data:_trace_event_security_file_open_set_in_multiple_policies_using_multiple_filter_types"
          "Test_EventFilters/comm:_event:_data:_trace_event_set_in_a_specific_policy_with_data_from_ls_command"
          "Test_EventFilters/comm:_event:_trace_events_set_in_two_specific_policies_from_ls_and_uname_commands"
          "Test_EventFilters/pid:_event:_data:_trace_event_sched_switch_with_data_from_pid_0"
          "Test_EventsDependencies/non_existing_ksymbol_dependency_with_sanity"
          "Test_EventsDependencies/non_existing_probe_function_with_sanity"
          "Test_EventsDependencies/sanity_of_exec_test_event"
          "Test_TraceeCapture/capture_packet_context"
        ];
      in
      ''
        with subtest("prepare for integration tests"):
          machine.wait_for_unit("docker.service")
          machine.succeed('which bash')

          # EventFilters/trace_only_events_from_new_containers also requires a container called "hello-world"
          machine.succeed('docker load < ${passthru.hello-world-builder pkgs}')

          # exec= needs fully resolved paths
          machine.succeed(
            'mkdir /tmp/testdir',
            'cp $(which who) /tmp/testdir/who',
            'cp $(which uname) /tmp/testdir/uname',
          )

        with subtest("run integration tests"):
          # Test_EventFilters/comm:_event:_data:_trace_event_set_in_a_specific_policy_with_data_from_ls_command expects to be in a dir that includes "integration"
          # tests must be ran with 1 process
          print(machine.succeed(
            'mkdir /tmp/integration',
            'cd /tmp/integration && integration.test -test.v -test.parallel 1 -test.skip="^${builtins.concatStringsSep "$|^" skippedTests}$"'
          ))
      '';
  }
)
