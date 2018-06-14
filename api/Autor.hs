{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Autor where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Network.HTTP.Types.Status

-- Cadastra 1 autor
postAutorCriarR :: Handler ()
postAutorCriarR = do
    pers <- requireJsonBody :: Handler Autor
    pid <- runDB $ insert pers
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey pid))])

-- Lista todos os Autores
getAutorListarR :: Handler Value
getAutorListarR = do
    pers <- runDB $ selectList [] [Asc AutorNome]
    sendResponse (object [pack "resp" .= toJSON pers])

-- Recebe 1 Autor
getAutorGetR :: AutorId -> Handler Value
getAutorGetR pid = do
    pers <- runDB $ get404 pid
    sendStatusJSON ok200 (object ["resp" .= pers])

-- Deleta 1 Autor
deleteAutorDeleteR :: AutorId -> Handler Value
deleteAutorDeleteR pid = do
	_ <- runDB $ get404 pid
	runDB $ delete pid
	sendStatusJSON noContent204 (object [])