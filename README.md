MCP-RALLY-VERIFY
=================

Steps:
---------

1. Clone repo to controller
2. Run prepare_env.sh
3. Source keystonerc
4. You can run tempest tests:
* rally verify start (for all tests and scenarios) or 
* rally verify start --pattern set=smoke (available suites for Tempest 14.0.0are full, smoke, compute, identity, image, network, object_storage, orchestration, volume, scenario)
* Moreover, users can run a certain set of tests, using a regular expression: rally verify start --pattern tempest.api.compute.admin.test_flavors.FlavorsAdminTestJSON
* In order to see errors of failed tests after the verification finished use the --detailed argument: rally verify start --pattern tempest.api.compute.admin.test_aggregates.AggregatesAdminTestJSON --detailed
5. Result: rally verify report --uuid uuid1 uuid2 uuidn --type html --to ./report.html
11. If you need rejoin to your last docker with rally - run rejoin.sh
12. If you want delete all dockers and files - run clean.sh
13. For debug with ipdb:
14. source debug
15. import ipdb ipdb.set_trace() to file with failed test 
16. python -m testtools.run tempest.api.volume.admin.test_volumes_backup.VolumesBackupsV2Test.test_volume_backup_create_get_detailed_list_restore_delete
