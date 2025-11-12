test_that("grab_target_list without tags return all object names in predefined config", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  # Get expected and actual values
  expected_target_list <- sort(
    c("obj_A", "obj_B", "obj_E", "obj_C", "obj_F", "obj_G", "obj_D", "obj_H")
  )
  actual_target_list <- sort(grab_target_list())

  # Test
  expect_equal(
    object = actual_target_list,
    expected = expected_target_list
  )
})

test_that("grab_target_list with tags returns all object names and
          dependencies belonging to the right tags in predefined config", {
            DARAutils::local_logger_sink()
            ## Init pipeline
            setup_pipeline_init()

            ## Get expected and actual values
            # t0
            expected_target_list_t0 <- c("obj_A") # Tag filter + no dependencies
            actual_target_list_t0 <- grab_target_list(tags = "t0")
            # t1
            expected_target_list_t1 <- sort(c("obj_B", # Tag filter
                                              "obj_A")) # Dependency
            actual_target_list_t1 <- sort(grab_target_list(tags = "t1"))
            # t2
            expected_target_list_t2 <- sort(
              c("obj_E", "obj_C", "obj_D", # Tag filter
                "obj_A", "obj_B" # Dependencies
              )
            )
            actual_target_list_t2 <- sort(grab_target_list(tags = "t2"))
            # t3
            expected_target_list_t3 <- sort(c("obj_G", # Tag filter
                                              "obj_E")) # Dependency
            actual_target_list_t3 <- sort(grab_target_list(tags = "t3"))

            ## Tests
            expect_equal(
              object = actual_target_list_t0,
              expected = expected_target_list_t0
            )
            expect_equal(
              object = actual_target_list_t1,
              expected = expected_target_list_t1
            )
            expect_equal(
              object = actual_target_list_t2,
              expected = expected_target_list_t2
            )
            expect_equal(
              object = actual_target_list_t3,
              expected = expected_target_list_t3
            )
          })

test_that("grab_target_list with objects returns all those object names and their dependencies", {
  DARAutils::local_logger_sink()
  ## Init pipeline
  setup_pipeline_init()

  ## Get expected and actual values
  # Object without dependencies
  expected_target_list_obj_no_dep <- c("obj_A") # Object filter + no dependencies
  actual_target_list_obj_no_dep <- grab_target_list(objects = c("obj_A"))
  # Object with dependency
  expected_target_list_obj_dep <- sort(c("obj_B", # Object filter
                                         "obj_A")) # Dependency
  actual_target_list_obj_dep <- sort(grab_target_list(objects = c("obj_B")))
  # Multiple objects with dependencies
  expected_target_list_m_obj_dep <- sort(
    c("obj_B", "obj_F", # Tag filter
      "obj_A", "obj_E" # Dependencies
    )
  )
  actual_target_list_m_obj_dep <- sort(grab_target_list(objects = c("obj_B", "obj_F")))

  ## Tests
  expect_equal(
    object = actual_target_list_obj_no_dep,
    expected = expected_target_list_obj_no_dep
  )
  expect_equal(
    object = actual_target_list_obj_dep,
    expected = expected_target_list_obj_dep
  )
  expect_equal(
    object = actual_target_list_m_obj_dep,
    expected = expected_target_list_m_obj_dep
  )
})

test_that("grab_target_list with both object and tags given return the right object names and their dependencies", {
  DARAutils::local_logger_sink()
  ## Init pipeline
  setup_pipeline_init()

  ## Get expected and actual values
  # Object with non-overlapping tag and object name
  expected_target_list_1 <- sort(
    c("obj_B", # Object name
      "obj_A", # Dependency obj_B
      "obj_G", # Tag t3
      "obj_E"  # Dependency tag t3
    )
  )
  actual_target_list_1 <- sort(grab_target_list(
    tags = "t3",
    objects = c("obj_B")
  ))
  # Object with overlapping tag and object name
  expected_target_list_2 <- sort(
    c("obj_B", # Object filter and tag t1 filter
      "obj_A" # Dependency
    )
  )
  actual_target_list_2 <- sort(grab_target_list(
    tags = "t1",
    objects = c("obj_B")
  ))
  # Multiple objects with overlapping or not overlapping tags
  expected_target_list_3 <- sort(
    c("obj_B", "obj_F", # Object filters and t1 filter (obj_B)
      "obj_A", "obj_E", # Dependencies and tag t3 dependency (obj_E)
      "obj_G" # tag t3 filter
    )
  )
  actual_target_list_3 <- sort(grab_target_list(
    tags = c("t1", "t3"),
    objects = c("obj_B", "obj_F")
  ))

  ## Tests
  expect_equal(
    object = actual_target_list_1,
    expected = expected_target_list_1
  )
  expect_equal(
    object = actual_target_list_2,
    expected = expected_target_list_2
  )
  expect_equal(
    object = actual_target_list_3,
    expected = expected_target_list_3
  )
})

test_that("existing tags are found", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  all_tags <- unique(grab_object_table()$tag)
  for (tag in all_tags) {
    expect_invisible(check_tags(tag, p_e = pipeline_env))
  }
})

test_that("non-existing tags give an error", {
  DARAutils::local_logger_sink()
  # Init pipeline
  setup_pipeline_init()

  non_existing_tag <- "non_existing_tag"
  expect_error(check_tags(non_existing_tag, p_e = pipeline_env),
               non_existing_tag)
})
