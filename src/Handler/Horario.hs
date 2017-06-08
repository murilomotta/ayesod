{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
 
module Handler.Horario where
import Yesod
import Foundation
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Applicative
import Data.Text

import Database.Persist.Postgresql


getListarHorarioR   :: Handler TypedContent   
getListarHorarioR = undefined

getCadastrarHorarioR   :: Handler TypedContent   
getCadastrarHorarioR = undefined

postCadastrarHorarioR   :: Handler TypedContent   
postCadastrarHorarioR = undefined
