#' National Electronic Injury Surveillance System
#'
#' The NEISS is a probability sample of hospital emergency departments in the
#' United States and its territories. This data set contains all data from
#' 2009 to 2014.
#'
#' @source \url{http://www.cpsc.gov/en/Research--Statistics/NEISS-Injury-Data/}
#' @format A data frame with 2,332,957 rows and 18 variables:
#' \describe{
#'   \item{case_num}{A unique identifer for each case}
#'   \item{trmt_date}{Date of treatment}
#'   \item{psu}{Primary sampling unit (hospital) identifier}
#'   \item{weight}{Weights adjusted for non-response, hospitals mergers and
#'     changes in sampling frame. Sum these weights to get national estimate.}
#'   \item{stratum}{}
#'   \item{age}{Age. Rounded to nearest month if under than 2, otherwise
#'     rounded to nearest year}
#'   \item{sex}{Sex: male, female, or unknown.}
#'   \item{race}{7-level race}
#'   \item{race_other}{Optional free form text for other races}
#'   \item{diag}{Diagnosis code. If multiple diagnoses, this is the most severe}
#'   \item{diag_other}{Free text for "other" diagnoses}
#'   \item{body_part}{Most seriously injured body part}
#'   \item{disposition}{Final disposition of case after university visit}
#'   \item{location}{Locale where injury occurred.}
#'   \item{fmv}{???}
#'   \item{prod1,prod2}{Consumer product codes}
#'   \item{narrative}{Description of what victim was doing, products involved,
#'    and locale of the incident (all upper case).}
#' }
"injuries"
