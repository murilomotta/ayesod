{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handler.Disciplina where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql

getListarDisciplinasR :: Handler TypedContent
getListarDisciplinasR = undefined

getCadastrarDisciplinasR :: Handler TypedContent
getCadastrarDisciplinasR = undefined

postCadastrarDisciplinasR :: Handler TypedContent
postCadastrarDisciplinasR = undefined
