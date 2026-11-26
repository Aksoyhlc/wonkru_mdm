/// A command's processing result: the ack body to send to the server and an
/// optional job to run only AFTER the ack is sent.
///
/// [afterAck] is for actions that kill the process (e.g. `reboot`): the ack
/// goes first and the action follows after a short delay, otherwise the action
/// never returns, the ack is never sent, and the server redelivers the command.
class CommandOutcome {
  const CommandOutcome(this.ack, {this.afterAck});

  final Map<String, dynamic> ack;

  final Future<void> Function()? afterAck;
}
