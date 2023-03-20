/*
* Created on 20 Mar 2023
* 
* @author Sai
* Copyright (c) 2023 Webknot
*/

/// Extensions
///
/// extension methods on int to convert int to
/// Duration(seconds: x) or Duration(milliseconds: x) 
extension DurationExtension on int {
  Duration get sec => Duration(seconds: this);
  Duration get ms => Duration(milliseconds: this);
}
