#' Load all mpc files
#'
#' @param files files to load
#' @param resolution the time resolution
#' @return data.frame with all files together
#' @export
#' @examples
#' data = find_files("/Users/dfreesto/Dropbox/Data/h/*.999") %>%
#'        mpc_load_files()
mpc_load_files = function(files, resolution=0.01)
{
  dplyr::bind_rows(lapply(files, mpc_load_file, resolution=resolution))
}

#' Load a single mpc file
#'
#' @param file file to load
#' @param resolution the time resolution
#' @return data.frame of a habitest file
#' @importFrom magrittr %>%
#' @export
#' @examples
#' data = mpc_load_file(file)
mpc_load_file = function(file, resolution=0.01)
{
  # as.numeric converts string names in NA by coercion, and outputs a warning.
  # suppress all warnings, for now, so that real warnings can be read later
  oldw <- getOption("warn")
  options(warn = -1)

  df = readr::read_csv(file,
                col_names=c("raw"),
                col_types="c") %>%
    dplyr::mutate(flush = mpcflushesc(as.numeric(.$raw), length(.$raw))) %>%
    dplyr::group_by(flush) %>%
    dplyr::mutate(subject=raw[7],
           date=paste0(raw[4], "/", raw[5], "/20", raw[6]),
           time=floor(as.numeric(raw)),
           event=round(1000 * (as.numeric(raw)-time)),
           time = time*resolution) %>%
    dplyr::ungroup() %>%
    dplyr::filter(event>0) %>%
    dplyr::select(-c(raw, flush))

  options(warn=oldw)
  return(df)
}

#' Cleanup mpc data.
#'
#' @param df data.frame of loaded mpc files
#' @param eventcodes A data_frame of event codes
#' @param files A list of csv files that specify event codes
#' @return data.frame with named event codes, and session numbers
#' @importFrom magrittr %>%
#' @export
#' @examples
#' data = find_files("~/Dropbox/Data/h/*.999") %>%
#'        mpc_load_files() %>%
#'        mpc_tidy(eventCodeFiles)
mpc_tidy = function(df, eventcodes=NULL, files=NULL)
{
  if (!is.null(files)){
    eventcodes = read_eventcodes(files)
  }

  df %>%
    dplyr::mutate(event = convert_codes_to_events(event, eventcodes),
                  session=session_fromdate(date),
                  subject=factor(subject),
                  date=factor(date))
}