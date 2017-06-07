{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell, ViewPatterns #-}
 
module Application where
import Foundation
import Yesod
import Usuario
import Handlers
import Front

import Handler.Professor
import Handler.Disciplina
import Handler.Horario
import Handler.Sala
import Handler.Usuario

-- Application
mkYesodDispatch "Sitio" resourcesSitio
