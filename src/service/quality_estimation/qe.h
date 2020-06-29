#pragma once
namespace marian {
namespace qe {

/// convert sentence score (log prob) to QE score
int sentence_score2qe_score(float sentence_score);

}} // end of namespace marian::qea
